From: akpm@linux-foundation.org
Subject: + v4l-mt9m111c-make-function-static.patch added to -mm tree
Date: Wed, 27 Aug 2008 16:09:27 -0700
Message-ID: <200808272309.m7RN9RWm027616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbYH0XJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 19:09:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     v4l: mt9m111.c make function static
has been added to the -mm tree.  Its filename is
     v4l-mt9m111c-make-function-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: mt9m111.c make function static
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/media/video/mt9m111.c:758:5: warning: symbol 'mt9m111_restore_state' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/mt9m111.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/mt9m111.c~v4l-mt9m111c-make-function-static drivers/media/video/mt9m111.c
--- a/drivers/media/video/mt9m111.c~v4l-mt9m111c-make-function-static
+++ a/drivers/media/video/mt9m111.c
@@ -755,7 +755,7 @@ static int mt9m111_set_control(struct so
 	return ret;
 }
 
-int mt9m111_restore_state(struct soc_camera_device *icd)
+static int mt9m111_restore_state(struct soc_camera_device *icd)
 {
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-mt9m111c-make-function-static.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-new-headers-for-make-headers-install.patch
pvrusb2-use-proper-byteorder-interface.patch

