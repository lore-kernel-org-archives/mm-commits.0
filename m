From: akpm@linux-foundation.org
Subject: + docbook-fix-kernel-api-content.patch added to -mm tree
Date: Mon, 15 Oct 2007 17:43:33 -0700
Message-ID: <200710160043.l9G0hXqm001113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbXJPAny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 20:43:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, rob@landley.net


The patch titled
     docbook: fix kernel-api content
has been added to the -mm tree.  Its filename is
     docbook-fix-kernel-api-content.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: docbook: fix kernel-api content
From: Randy Dunlap <randy.dunlap@oracle.com>


Fix kernel-api docbook warnings.

Warning(linux-2.6.23-git8//drivers/message/fusion/mptscsih.c:2618): No description found for parameter 'sc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~docbook-fix-kernel-api-content drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~docbook-fix-kernel-api-content
+++ a/drivers/message/fusion/mptscsih.c
@@ -2605,14 +2605,10 @@ mptscsih_set_scsi_lookup(MPT_ADAPTER *io
 }
 
 /**
- * SCPNT_TO_LOOKUP_IDX
- *
- * search's for a given scmd in the ScsiLookup[] array list
- *
+ * SCPNT_TO_LOOKUP_IDX - searches for a given scmd in the ScsiLookup[] array list
  * @ioc: Pointer to MPT_ADAPTER structure
- * @scmd: scsi_cmnd pointer
- *
- **/
+ * @sc: scsi_cmnd pointer
+ */
 static int
 SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *sc)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
git-nfsd.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
comment-typo-in-scripts-kconfig-makefile.patch
docbook-fix-kernel-api-content.patch
docbook-fix-libata-content.patch
docbook-fix-usb-content.patch
docbook-fix-filesystems-content.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
