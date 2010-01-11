From: akpm@linux-foundation.org
Subject: [merged] gitignore-ignore-vmlinuz.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:25 -0800
Message-ID: <201001112018.o0BKIP7H025487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000Ab0AKUTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ffainelli@freebox.fr, mbizon@freebox.fr, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     .gitignore: ignore vmlinuz
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-vmlinuz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

