From: akpm@linux-foundation.org
Subject: - docbook-fix-libata-content.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:46:02 -0700
Message-ID: <200710162046.l9GKk2BR016327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965498AbXJPU64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     docbook: fix libata content
has been removed from the -mm tree.  Its filename was
     docbook-fix-libata-content.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docbook: fix libata content
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix libata docbook warnings.

Warning(linux-2.6.23-git8//drivers/ata/libata-scsi.c:3251): No description found for parameter 'dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-scsi.c~docbook-fix-libata-content drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~docbook-fix-libata-content
+++ a/drivers/ata/libata-scsi.c
@@ -3240,7 +3240,7 @@ static void ata_scsi_handle_link_detach(
 
 /**
  *	ata_scsi_media_change_notify - send media change event
- *	@atadev: Pointer to the disk device with media change event
+ *	@dev: Pointer to the disk device with media change event
  *
  *	Tell the block layer to send a media change notification
  *	event.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
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
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
