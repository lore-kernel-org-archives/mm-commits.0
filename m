From: akpm@linux-foundation.org
Subject: + readme-cite-nconfig.patch added to -mm tree
Date: Thu, 12 Aug 2010 14:38:40 -0700
Message-ID: <201008122138.o7CLce6n014120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970Ab0HLVjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 17:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea.gelmini@gelma.net, mmarek@suse.cz


The patch titled
     ./README: cite nconfig
has been added to the -mm tree.  Its filename is
     readme-cite-nconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ./README: cite nconfig
From: Andrea Gelmini <andrea.gelmini@gelma.net>

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 README |    1 +
 1 file changed, 1 insertion(+)

diff -puN README~readme-cite-nconfig README
--- a/README~readme-cite-nconfig
+++ a/README
@@ -166,6 +166,7 @@ CONFIGURING the kernel:
  - Alternate configuration commands are:
 	"make config"      Plain text interface.
 	"make menuconfig"  Text based color menus, radiolists & dialogs.
+	"make nconfig"     Enhanced text based color menus.
 	"make xconfig"     X windows (Qt) based configuration tool.
 	"make gconfig"     X windows (Gtk) based configuration tool.
 	"make oldconfig"   Default all questions based on the contents of
_

Patches currently in -mm which might be from andrea.gelmini@gelma.net are

origin.patch
linux-next.patch
readme-cite-nconfig.patch

