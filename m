From: akpm@linux-foundation.org
Subject: + documentation-sysctl-kerneltxt-fix-documentation-reference.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:56:36 -0800
Message-ID: <200802122356.m1CNuamX029741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761978AbYBLX5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael-lists@free-electrons.com, michael@free-electrons.com, rdunlap@xenotime.net


The patch titled
     Documentation: sysctl/kernel.txt: fix documentation reference
has been added to the -mm tree.  Its filename is
     documentation-sysctl-kerneltxt-fix-documentation-reference.patch

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
documentation-sysctl-kerneltxt-fix-documentation-reference.patch
