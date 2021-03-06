require "test_helper"

describe WorksController do

  let(:book1) { works(:book1) }
  let(:book2) { works(:book2) }
  let(:album1) { works(:album1) }

  describe "CRUD methods" do
    describe "index" do
      it "should get index" do
        get works_path
        must_respond_with :success
      end
    end #index

    describe "show" do
      it "should display the Work detail page if id is valid" do
        get work_path(book1.id)
        must_respond_with :success
      end

      it "will render 404 page if id isn't found" do
        get work_path(Work.last.id + 1)
        must_respond_with :not_found
      end
    end #show

    describe "new" do
      it "should display a form for a new Work" do
        get new_work_path
        must_respond_with :success
      end
    end #new

    describe "create" do
      it "should create create a new Work if input is valid" do
        proc { post works_path, params: { work: { title: "#{book1.title} 2", category: "book" } } }.must_change 'Work.count', 1
        must_respond_with :redirect
      end

      it "re-renders the new form if input is invalid" do
        proc { post works_path, params: { work: { category: "book"} } }.must_change 'Work.count', 0
        must_respond_with :bad_request
      end
    end #create

    describe "edit" do
      it "should display an edit form if id is valid" do
        get edit_work_path(book1.id)
        must_respond_with :success
      end

      it "will render 404 page if id isn't found" do
        get edit_work_path(Work.last.id + 1)
        must_respond_with :not_found
      end
    end #edit

    describe "update" do
      it "will render 404 page if id isn't found" do
        get update_work_path(Work.last.id + 1)
        must_respond_with :not_found
      end

      it "should update the Work if the input is valid" do
        old_title = book1.title
        patch work_path(book1.id), params: {work: {title: "#{book1.title} Updated"}}

        book1_updated = Work.find(book1.id)
        book1_updated.title.must_equal "#{old_title} Updated"
      end

      it "re-renders the edit form if input is invalid" do
        patch work_path(book2.id), params: { work: { category: nil } }
        book2.category.must_equal "book"
        must_respond_with :bad_request
      end
    end #update

    describe "destroy" do
      it "will render 404 page if id isn't found" do
        delete delete_work_path(Work.last.id + 1)
        must_respond_with :not_found
      end

      it "should destroy a Work if Work has no votes" do
        proc { delete delete_work_path(book1.id) }.must_change 'Work.count', -1
        must_respond_with :redirect

        Work.find_by(id: book1.id).must_be_nil
      end

      it "should not destroy a Work if Work has votes" do
        proc { delete delete_work_path(album1.id) }.must_change 'Work.count', 0
        must_respond_with :redirect

        Work.find_by(id: album1.id).wont_be_nil
      end
    end #destroy
  end # CRUD Tests

  describe "Other Controller Methods" do
    it "should display a root page (home)" do
      get root_path
      must_respond_with :success
    end

    #TODO Ask how to test strong params
  end
end
