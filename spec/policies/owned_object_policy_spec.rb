require 'spec_helper'

describe OwnedObjectPolicy do
  subject { OwnedObjectPolicy }

  permissions :read? do
    let(:user) { build(:user) }

    context "project is public" do
      let(:project) { build(:project, visibility: "public") }
      it "should permit access if the project is public" do
        expect(subject).to permit(user, project)
      end

      it "should permit access if the project is public and there is no user" do
        expect(subject).to permit(nil, project)
      end
    end

    context "project is private" do
      let(:project) { build(:project, visibility: "private", owner: user) }
      
      it "should permit the owner access" do
        expect(subject).to permit(user, project)
      end

      it "should not permit a non-logged in user" do
        expect(subject).to_not permit(nil, project)
      end

      it "should permit an admin user" do
        admin = build(:user)
        admin.add_role :admin
        expect(subject).to permit(admin, project)
      end

      it "should permit a user with the proper role" do
        collab = create(:user)
        collab.add_role :collaborator, project
        expect(subject).to permit(collab, project)
      end
    end
  end

  permissions :create? do
    let(:project) { build(:project) }

    it "should permit the user to create a project" do
      expect(subject).to permit(build(:user), project)
    end

    let(:user) { nil }

    it "should not a permit a non-logged in user to create a project" do
      expect(subject).to_not permit(user, project)
    end
  end

  permissions :update? do
    let(:user) { build(:user) }
    let(:project) { build(:project, owner: user) }

    it "should permit the project owner to update" do
      expect(subject).to permit(user, project)
    end

    it "should permit an admit user to update" do
      admin = build(:user)
      admin.add_role :admin
      expect(subject).to permit(admin, project)
    end

    it "should not permit a non-owner user to update" do
      expect(subject).to_not permit(build(:user), project)
    end

    it "should not permit a non-logged in user to update" do
      expect(subject).to_not permit(nil, project)
    end
  end

  permissions :delete? do
    let(:user) { build(:user) }
    let(:project) { build(:project, owner: user) }

    it "should permit the project owner to delete" do
      expect(subject).to permit(user, project)
    end

    it "should permit an admit user to delete" do
      admin = build(:user)
      admin.add_role :admin
      expect(subject).to permit(admin, project)
    end

    it "should not permit a non-owner user to delete" do
      expect(subject).to_not permit(build(:user), project)
    end

    it "should not permit a non-logged in user to delete" do
      expect(subject).to_not permit(nil, project)
    end
  end
end