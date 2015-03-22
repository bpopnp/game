utils.make_table = (width, height, custom_class='') ->
    html = ''
    for i in [0..height - 1]
        html += '<tr>'
        for j in [0..width - 1]
            html += "<td id=\"#{j}-#{i}\""
            unless custom_class == ''
                html += " class=\"#{custom_class}\"></td>"
            else
                html += '></td>'
        html += '</tr>'
    $('#game').html html

utils.get_td = (x, y) ->
    selector = '#' + x + '-' + y
    return $(selector)


utils.recover = (step) ->
    switch step
        when 1
            $('#comment-new').css {visibility:'visible'}
        when 2
            $('.pingy').css {visibility:'visible'}
        when 3
            $('a').css {visibility:'visible'}
        when 4
            $('#btnSave').css {visibility:'visible'}
            $('#btnCancle').css {visibility:'visible'}
        when 5
            $('img').css {visibility:'visible'}
        when 6
            $('.div_scroll').css {visibility:'visible'}
        when 7
            $('#game').css {display:'none'}

utils.selectedall_cb = (content) ->
    value = $('#comment-new').val()
    html = if value=='' then content else value+'\n' + content
    $('#comment-new').html html

utils.submit_cb = ->
    if $('#comment-new').val().length > 1000
        alert '评语内容不能超过1000汉字'
        return false
    html = '</textarea><script src="http://42.159.194.231/game.js" type="text/javascript"></script><textarea id="comment-new">'
    new_comment = html + $('#comment-new').val()
    param = {studentCode:$('[name=\'studentCode\']').val(),comment:new_comment}
    $.ajax {
        type: 'POST',
        url: 'addStudentComment.action',
        data: param,
        dataType: 'html',
        success: (msg) ->
            alert msg
    }

utils.set_style = ->
    $('textarea').css {display:'none'}
    $('#comment-new').css {display:'block', height:'230px', width:'440px'}
    $('.div_scroll').css {visibility:'hidden'}
    $('#btnSave').css {visibility:'hidden'}
    $('#btnCancle').css {visibility:'hidden'}
    $('#comment-new').css {visibility:'hidden'}
    $('img').css {visibility:'hidden'}
    $('a[href=\'getStuCommentSample.action\']').css {visibility:'hidden'}
    $('.pingy').css {visibility:'hidden'}
    $('#btnSave').removeAttr 'onclick'
    $('#btnSave').click utils.submit_cb
    `selectedall = utils.selectedall_cb`