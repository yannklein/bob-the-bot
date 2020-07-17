require "ibm_watson/visual_recognition_v3"

include IBMWatson

def fetch_ibm_watson(response_image)
  tf = Tempfile.open
  tf.write(response_image.body)
  # Using IBM Watson visual recognition API
  visual_recognition = VisualRecognitionV3.new(
    version: "2018-03-19",
    iam_apikey: ENV["IBM_IAM_API_KEY"]
  )
  image_results = ""
  File.open(tf.path) do |images_file|
    classes = visual_recognition.classify(
      images_file: images_file,
      threshold: "0.6"
    )
    image_results = classes.result["images"][0]["classifiers"][0]["classes"]
    image_results = image_results.map {|result| result["class"].upcase}
  end
  # Do something with the image results
  yield(image_results)
  tf.unlink
end
