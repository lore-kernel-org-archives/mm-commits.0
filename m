From: akpm@linux-foundation.org
Subject: [patch 35/51] include/linux/bitfield.h: remove 32bit from
 FIELD_GET comment block
Date: Tue, 03 Oct 2017 16:16:04 -0700
Message-ID: <59d41a34.oDxOhE9cnWMzYnvm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com, jakub.kicinski@netronome.com

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
