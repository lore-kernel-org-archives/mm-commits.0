From: akpm@linux-foundation.org
Subject: [merged]
 memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch
 removed from -mm tree
Date: Fri, 29 Jul 2016 11:56:30 -0700
Message-ID: <579ba6de.w6RurAK89JuXLkSJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbcG2S4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: include <asm/sections.h> instead of <asm-generic/sections.h>
has been removed from the -mm tree.  Its filename was
     memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: memblock: include <asm/sections.h> instead of <asm-generic/sections.h>

asm-generic headers are generic implementations for architecture specific
code and should not be included by common code.  Thus use the asm/ version
of sections.h to get at the linker sections.

Link: http://lkml.kernel.org/r/1468285103-7470-1-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh mm/memblock.c
--- a/mm/memblock.c~memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh
+++ a/mm/memblock.c
@@ -20,7 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 
-#include <asm-generic/sections.h>
+#include <asm/sections.h>
 #include <linux/io.h>
 
 #include "internal.h"
_

Patches currently in -mm which might be from hch@lst.de are

printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

