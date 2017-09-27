From: akpm@linux-foundation.org
Subject: + bitfieldh-remove-32bit-from-field_get-comment-block.patch added to -mm tree
Date: Tue, 26 Sep 2017 17:22:34 -0700
Message-ID: <59caef4a.14WPgZOM4DxoTyUP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964956AbdI0AWf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2017 20:22:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, jakub.kicinski@netronome.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bitfield.h: remove 32bit from FIELD_GET comment block
has been added to the -mm tree.  Its filename is
     bitfieldh-remove-32bit-from-field_get-comment-block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitfieldh-remove-32bit-from-field_get-comment-block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitfieldh-remove-32bit-from-field_get-comment-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: include/linux/bitfield.h: remove 32bit from FIELD_GET comment block

I do not see anything that restricts this macro to 32 bit width.

Link: http://lkml.kernel.org/r/1505921975-23379-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitfield.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bitfield.h~bitfieldh-remove-32bit-from-field_get-comment-block include/linux/bitfield.h
--- a/include/linux/bitfield.h~bitfieldh-remove-32bit-from-field_get-comment-block
+++ a/include/linux/bitfield.h
@@ -92,7 +92,7 @@
 /**
  * FIELD_GET() - extract a bitfield element
  * @_mask: shifted mask defining the field's length and position
- * @_reg:  32bit value of entire bitfield
+ * @_reg:  value of entire bitfield
  *
  * FIELD_GET() extracts the field specified by @_mask from the
  * bitfield passed in as @_reg by masking and shifting it down.
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

bitfieldh-remove-32bit-from-field_get-comment-block.patch

