From: akpm@linux-foundation.org
Subject: + gitignore-ignore-vmlinuz.patch added to -mm tree
Date: Wed, 06 Jan 2010 15:14:31 -0800
Message-ID: <201001062314.o06NEVrR024019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932541Ab0AFXPP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 18:15:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ffainelli@freebox.fr, mbizon@freebox.fr, ralf@linux-mips.org


The patch titled
     .gitignore: ignore vmlinuz
has been added to the -mm tree.  Its filename is
     gitignore-ignore-vmlinuz.patch

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
Subject: .gitignore: ignore vmlinuz
From: Florian Fainelli <ffainelli@freebox.fr>

MIPS compressed kernels output a vmlinuz file in the top-level directory
(maybe others do).  Add vmlinuz to the list of files to ignore by git.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-ignore-vmlinuz .gitignore
--- a/.gitignore~gitignore-ignore-vmlinuz
+++ a/.gitignore
@@ -37,6 +37,7 @@ modules.builtin
 tags
 TAGS
 vmlinux
+vmlinuz
 System.map
 Module.markers
 Module.symvers
_

Patches currently in -mm which might be from ffainelli@freebox.fr are

gitignore-ignore-vmlinuz.patch

