From: akpm@linux-foundation.org
Subject: - mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:08:44 -0700
Message-ID: <200710160408.l9G48ikh008014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbXJPEI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, hifumi.hisashi@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     mm-use-pagevec-to-rotate-reclaimable-page: fix function declaration
has been removed from the -mm tree.  Its filename was
     mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch

This patch was dropped because it was folded into mm-use-pagevec-to-rotate-reclaimable-page.patch

------------------------------------------------------
Subject: mm-use-pagevec-to-rotate-reclaimable-page: fix function declaration
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function declaration:
mm/swap.c:130:22: warning: non-ANSI function declaration of function 'move_tail_pages'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration
+++ a/mm/swap.c
@@ -125,7 +125,7 @@ static void pagevec_move_tail(struct pag
 
 static DEFINE_PER_CPU(struct pagevec, rotate_pvecs) = { 0, };
 
-void move_tail_pages()
+void move_tail_pages(void)
 {
 	unsigned long flags;
 	struct pagevec *pvec;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
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
docbook-fix-filesystems-content.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
