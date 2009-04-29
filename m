From: akpm@linux-foundation.org
Subject: [merged] es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:47 -0700
Message-ID: <200904291917.n3TJHlg0030758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403AbZD2TTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:19:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     input: fix function arg list
has been removed from the -mm tree.  Its filename was
     es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: fix function arg list
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function args build warning:

mmotm-2008-1230-1605/drivers/input/input.c:1661: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/input.c~es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix drivers/input/input.c
--- a/drivers/input/input.c~es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix
+++ a/drivers/input/input.c
@@ -1648,7 +1648,7 @@ static const struct file_operations inpu
 	.open = input_open_file,
 };
 
-static void __init input_init_abs_bypass()
+static void __init input_init_abs_bypass(void)
 {
 	const unsigned int *p;
 	for (p = input_abs_bypass_init_data; *p; p++)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
ecryptfs-fix-printk-format-warning.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
kernel-doc-restrict-syntax-for-private-and-public.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

