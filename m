From: akpm@linux-foundation.org
Subject: + parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:54:44 -0700
Message-ID: <200803110554.m2B5siUY025166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbYCKFze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     parisc: remove redundant display of free swap space in show_mem()
has been added to the -mm tree.  Its filename is
     parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch

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
Subject: parisc: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/parisc/mm/init.c~parisc-remove-redundant-display-of-free-swap-space-in-show_mem arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~parisc-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/parisc/mm/init.c
@@ -555,8 +555,6 @@ void show_mem(void)
 
 	printk(KERN_INFO "Mem-info:\n");
 	show_free_areas();
-	printk(KERN_INFO "Free swap:	 %6ldkB\n",
-				nr_swap_pages<<(PAGE_SHIFT-10));
 #ifndef CONFIG_DISCONTIGMEM
 	i = max_mapnr;
 	while (i-- > 0) {
_

Patches currently in -mm which might be from hannes@saeurebad.de are

arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ppc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
xtensa-remove-redundant-display-of-free-swap-space-in-show_mem.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch

