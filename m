From: akpm@linux-foundation.org
Subject: - byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:08:41 -0700
Message-ID: <200810222008.m9MK8fR2013815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYJVUIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: remove direct includes of linux/byteorder/swab[b].h
has been removed from the -mm tree.  Its filename was
     byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: remove direct includes of linux/byteorder/swab[b].h
From: Harvey Harrison <harvey.harrison@gmail.com>

A consolidated implementation will provide this generically through
asm/byteorder, remove direct includes to avoid breakage when the
changeover to the new implementation occurs.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh kernel/rcutorture.c
--- a/kernel/rcutorture.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh
+++ a/kernel/rcutorture.c
@@ -42,10 +42,10 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-remove-__function__-in-video-driver.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

