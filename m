From: akpm@linux-foundation.org
Subject: [merged] gitignore-ignore-tar.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:59 -0700
Message-ID: <5535519b.nAYEUAFI7/03TCww%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbDTTOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrej.skvortzov@gmail.com, ak@linux.intel.com, benjamin.romer@unisys.com, boaz@plexistor.com, gregkh@linuxfoundation.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: .gitignore: ignore *.tar
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-tar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: .gitignore: ignore *.tar

Running make tar-pkg results in following:

 # Untracked files:
 #   (use "git add <file>..." to include in what will be committed)
 #
 #       linux-4.0.0-rc3-next-20150313-150225--x86.tar

This patch makes git ignore *.tar files.
Running 'git ls-files -i --exclude-standard' does not show any
tar files excluded from tracking after the change.

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-ignore-tar .gitignore
--- a/.gitignore~gitignore-ignore-tar
+++ a/.gitignore
@@ -24,6 +24,7 @@
 *.order
 *.elf
 *.bin
+*.tar
 *.gz
 *.bz2
 *.lzma
_

Patches currently in -mm which might be from andrej.skvortzov@gmail.com are

origin.patch

