From: akpm@linux-foundation.org
Subject: - elf-use-ei_nident-instead-of-numeric-value.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:07 -0700
Message-ID: <200804300545.m3U5j7UG029476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbYD3Fpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ELF: Use EI_NIDENT instead of numeric value
has been removed from the -mm tree.  Its filename was
     elf-use-ei_nident-instead-of-numeric-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ELF: Use EI_NIDENT instead of numeric value
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/elf.h~elf-use-ei_nident-instead-of-numeric-value include/linux/elf.h
--- a/include/linux/elf.h~elf-use-ei_nident-instead-of-numeric-value
+++ a/include/linux/elf.h
@@ -208,7 +208,7 @@ typedef struct elf32_hdr{
 } Elf32_Ehdr;
 
 typedef struct elf64_hdr {
-  unsigned char	e_ident[16];		/* ELF "magic number" */
+  unsigned char	e_ident[EI_NIDENT];	/* ELF "magic number" */
   Elf64_Half e_type;
   Elf64_Half e_machine;
   Elf64_Word e_version;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-acpi.patch
git-m32r.patch

