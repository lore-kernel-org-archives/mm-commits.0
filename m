From: akpm@linux-foundation.org
Subject: - v4l-mt9m111c-make-function-static.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:27 -0700
Message-ID: <200809022041.m82KfR2N011637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499AbYIBUl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     v4l: mt9m111.c make function static
has been removed from the -mm tree.  Its filename was
     v4l-mt9m111c-make-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
rcu-spinlocks-take-an-unsigned-long-flags.patch
rcu-fix-sparse-shadowed-variable-warning.patch
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
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch

