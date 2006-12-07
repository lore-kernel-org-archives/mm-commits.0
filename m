From: akpm@osdl.org
Subject: - kbuild-add-3-more-header-files-to-get-properly-unifdefed.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:11 -0800
Message-ID: <200612072316.kB7NGBMY030798@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53683 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163787AbWLGXQw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, dwmw2@infradead.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Kbuild: add 3 more header files to get properly "unifdef"ed
has been removed from the -mm tree.  Its filename was
     kbuild-add-3-more-header-files-to-get-properly-unifdefed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kbuild: add 3 more header files to get properly "unifdef"ed
From: "Robert P. J. Day" <rpjday@mindspring.com>

Add 3 more files to get "unifdef"ed when creating sanitized headers with
"make headers_install".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/Kbuild |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/Kbuild~kbuild-add-3-more-header-files-to-get-properly-unifdefed include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-add-3-more-header-files-to-get-properly-unifdefed
+++ a/include/linux/Kbuild
@@ -221,6 +221,7 @@ unifdef-y += if_bridge.h
 unifdef-y += if_ec.h
 unifdef-y += if_eql.h
 unifdef-y += if_ether.h
+unifdef-y += if_fddi.h
 unifdef-y += if_frad.h
 unifdef-y += if_ltalk.h
 unifdef-y += if_pppox.h
@@ -282,6 +283,7 @@ unifdef-y += nvram.h
 unifdef-y += parport.h
 unifdef-y += patchkey.h
 unifdef-y += pci.h
+unifdef-y += personality.h
 unifdef-y += pktcdvd.h
 unifdef-y += pmu.h
 unifdef-y += poll.h
@@ -337,6 +339,7 @@ unifdef-y += videodev.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h
+unifdef-y += wireless.h
 unifdef-y += xfrm.h
 
 objhdr-y += version.h
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
schedc-correct-comment-for-this_rq_lock-routine.patch

