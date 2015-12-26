#= require vendor/qiniu_direct_uploader

$(document).ready(function() {
  var createVideoForm;
  createVideoForm = $("form#create-video-uploader");
  if (createVideoForm.length > 0) {
    createVideoForm.QiniuUploader({
      autoUpload: true,
      removeProgressBarWhenCompleted: true,
	allowMultipleFiles: true,
      onFilesAdd: function(file) {
        types = /(\.|\/)(doc|docx|mov|mp4|jpg|jpeg|png)$/i;
        if (types.test(file.type) || types.test(file.name)) {
          if (file.size > 100000000) {
            alert("上传失败：" + file.name + " 附件太大，超过100M");
            return false;
          } else {
            return true;
          }
        } else {
          alert("上传失败：" + file.name + " 附件格式错误，请上传mov或mp4文件");
          return false;
        }
      }
    });
    createVideoForm.bind("qiniu_upload_start", function(e) {
      $('#submit_video_info').attr('value', '附件正在上传');
      $('#submit_video_info').attr('disabled', 'true');
      $('a.fileupload-btn').bind('click', false);
    });
    createVideoForm.bind("qiniu_upload_complete", function(e, data) {
      $('#progress-text').html("附件上传成功！");
      $('#video-filename').html("附件文件名： " + "<strong>" + data.fname + "</strong>");
    });
  }
});
