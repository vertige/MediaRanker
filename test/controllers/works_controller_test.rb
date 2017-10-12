require "test_helper"

describe WorksController do

  let(:book1) { works(:book1) }
  let(:book2) { works(:book2) }

  it "should get index" do
    get works_path
    must_respond_with :success
  end

  it "should get work detail page (#show) or render a 404" do
    #true
    get work_path(book1.id)
    must_respond_with :success

    #false
    book1.destroy
    get work_path(book1.id)
    must_respond_with :not_found
  end

  it "should display a form for a new Work" do
    get new_work_path
    must_respond_with :success
  end

  it "should create a new Work" do
    #false - invalid without title
    proc { post works_path, params: { work: { category: "book"} } }.must_change 'Work.count', 0
    must_respond_with :success #renders

    #true
    proc { post works_path, params: { work: { title: "#{book1.title} 2", category: "book" } } }.must_change 'Work.count', 1
    must_respond_with :redirect
  end

  it "should update the work" do
    #true
    old_title = book1.title
    patch work_path(book1.id), params: {work: {title: "#{book1.title} Updated"}}

    book1_updated = Work.find(book1.id)
    book1_updated.title.must_equal "#{old_title} Updated"
    must_redirect_to work_path(book1.id)

    #false - duplicate title and category of another work in db
    # patch work_path(book2.id), params: {work: {title: book1.title, category: book1.category}}
    # must_respond_with :error
    #TODO redirects... is valid?

    #false - non existent id
    # patch work_path("pamplemousse"), params: { work: { title: "Doesn't Matter" } }
    # must_respond_with :not_found
    #TODO "undefined method 'errors' for nil"
  end

  it "should display an edit form" do
    #true
    get edit_work_path(book1.id)
    must_respond_with :success

    #false
    book1.destroy
    get edit_work_path(book1.id)
    must_respond_with :not_found
  end
  #
  # it "should get destroy" do
  #   get works_destroy_url
  #   value(response).must_be :success?
  # end
end
