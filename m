From: akpm@linux-foundation.org
Subject: - kallsyms-nuke-all-changelog-this-should-be-logged-by-git.patch removed from -mm tree
Date: Thu, 01 May 2008 02:24:54 -0700
Message-ID: <200805010924.m419OsvA030148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755304AbYEAJZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, pmarques@grupopie.com, mm-commits@vger.kernel.org


The patch titled
     kallsyms: nuke all ChangeLog, this should be logged by git
has been removed from the -mm tree.  Its filename was
     kallsyms-nuke-all-changelog-this-should-be-logged-by-git.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kallsyms: nuke all ChangeLog, this should be logged by git
From: Bryan Wu <cooloney@kernel.org>

Pointed out by Paulo:
"When I wrote this initially, it was a mistake to add a Changelog
in the first place, but I didn't know better at the time.

If you're going to make changes to this file, please remove all the Changelog,
instead of adding more entries to it.  The "Changelog" should be kept by the
version control system, and not the source code itself."

Cc: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: Paulo Marques <pmarques@grupopie.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kallsyms.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN scripts/kallsyms.c~kallsyms-nuke-all-changelog-this-should-be-logged-by-git scripts/kallsyms.c
--- a/scripts/kallsyms.c~kallsyms-nuke-all-changelog-this-should-be-logged-by-git
+++ a/scripts/kallsyms.c
@@ -7,12 +7,6 @@
  *
  * Usage: nm -n vmlinux | scripts/kallsyms [--all-symbols] > symbols.S
  *
- * ChangeLog:
- *
- * (25/Aug/2004) Paulo Marques <pmarques@grupopie.com>
- *      Changed the compression method from stem compression to "table lookup"
- *      compression
- *
  *      Table compression uses all the unused char codes on the symbols and
  *  maps these to the most used substrings (tokens). For instance, it might
  *  map char code 0xF7 to represent "write_" and then in every symbol where
_

Patches currently in -mm which might be from cooloney@kernel.org are

origin.patch
git-watchdog.patch
spi_bfin5xx-use-pio-for-full-duplex-not-dma.patch

