require 'spec_helper'

describe Crystal::AfterTypeInferenceTransformer do
  it "keeps else of if with nil type" do
    assert_after_type_inference "a = nil; if a; 1; else; 2; end",
      "a = nil\na\n2"
  end

  it "keeps then of if with true literal" do
    assert_after_type_inference "if true; 1; else; 2; end",
      "1"
  end

  it "keeps else of if with false literal" do
    assert_after_type_inference "if false; 1; else; 2; end",
      "2"
  end

  it "keeps then of if with true assignment" do
    assert_after_type_inference "if a = true; 1; else; 2; end",
      "a = true\n1"
  end

  it "keeps else of if with false assignment" do
    assert_after_type_inference "if a = false; 1; else; 2; end",
      "a = false\n2"
  end

  it "keeps else of if with is_a? that can never hold" do
    assert_after_type_inference "a = 1; if a.is_a?(Bool); 2; else 3; end",
      "a = 1\n3"
  end

  it "errors comparison of unsigned integer with zero or negative literal" do
    error = "comparison of unsigned integer with zero or negative literal will always be false"
    assert_error "1_u32 < 0", error
    assert_error "1_u32 <= -1", error
    assert_error "0 > 1_u32", error
    assert_error "-1 >= 1_u32", error
  end
end