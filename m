From: akpm@linux-foundation.org
Subject: - documentation-sysctl-kerneltxt-fix-documentation-reference.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:04 -0500
Message-ID: <200802150226.m1F2QNCb015219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764950AbYBOC0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael-lists@free-electrons.com, michael@free-electrons.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Documentation: sysctl/kernel.txt: fix documentation reference
has been removed from the -mm tree.  Its filename was
     documentation-sysctl-kerneltxt-fix-documentation-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: sysctl/kernel.txt: fix documentation reference
From: Michael Opdenacker <michael-lists@free-electrons.com>

This patch fixes a reference to Documentation/kmod.txt
which was apparently renamed to Documentation/debugging-modules.txt

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-fix-documentation-reference Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-fix-documentation-reference
+++ a/Documentation/sysctl/kernel.txt
@@ -29,7 +29,7 @@ show up in /proc/sys/kernel:
 - java-interpreter            [ binfmt_java, obsolete ]
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
-- modprobe                    ==> Documentation/kmod.txt
+- modprobe                    ==> Documentation/debugging-modules.txt
 - msgmax
 - msgmnb
 - msgmni
_

Patches currently in -mm which might be from michael-lists@free-electrons.com are

origin.patch
