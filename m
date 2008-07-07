From: akpm@linux-foundation.org
Subject: - man-pages-is-supported.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:04:43 -0700
Message-ID: <200807070304.m6734iK9004687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbYGGDEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     man-pages is supported
has been removed from the -mm tree.  Its filename was
     man-pages-is-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: man-pages is supported
From: Michael Kerrisk <mtk.manpages@googlemail.com>

Starting last month, I reached a long-time goal: man-pages finally has a
paid, full-time maintainer, thanks to a fellowship from the Linux
Foundation.  It's still a little unclear how long the LF money will last
for the fellowship, but for the foreseeable future, I'll be working on:

* Properly documenting every new Linux kernel-userland (and glibc) API,
  and every API change, that is released into the mainline kernel, ideally
  before actual release.  (That's the ideal, but there's a quite a
  backlog, so I'm not going to achieve the ideal immediately.)

* Testing new APIs, again ideally before they are released into the
  mainline kernel, and probably doing some light bug fixing while I'm at
  it (e.g., the recent utimensat() work).

* Design review of new APIs, which of course can only usefully be done
  before they are released into the mainline kernel.

* And of course accepting patches and dealing with bug reports for
  existing man pages.

Signed-off-by: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~man-pages-is-supported MAINTAINERS
--- a/MAINTAINERS~man-pages-is-supported
+++ a/MAINTAINERS
@@ -2684,8 +2684,8 @@ S: 	Supported
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
-W:	ftp://ftp.kernel.org/pub/linux/docs/manpages
-S:	Maintained
+W:     http://www.kernel.org/doc/man-pages
+S:     Supported
 
 MARVELL LIBERTAS WIRELESS DRIVER
 P:	Dan Williams
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-socket-and-socketpair-mips-fix.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd.patch
flag-parameters-eventfd-fix.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parameters-inotify_init-fix.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch
flag-parameters-check-magic-constants-alpha.patch
flag-parameters-add-on-remove-epoll_create-size-param.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch

