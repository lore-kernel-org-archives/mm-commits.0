From: akpm@linux-foundation.org
Subject: [merged]
 bitfieldh-remove-32bit-from-field_get-comment-block.patch removed from -mm
 tree
Date: Wed, 04 Oct 2017 12:41:34 -0700
Message-ID: <20171004194134.m-zdLg5oq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTlf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jakub.kicinski@netronome.com, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: include/linux/bitfield.h: remove 32bit from FIELD_GET comment block
has been removed from the -mm tree.  Its filename was
     bitfieldh-remove-32bit-from-field_get-comment-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

bitfieldh-include-linux-build_bugh-instead-of-linux-bugh.patch
radix-tree-remove-unneeded-include-linux-bugh.patch
init-version-include-linux-exporth-instead-of-linux-moduleh.patch

