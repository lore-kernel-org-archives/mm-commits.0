From: akpm@linux-foundation.org
Subject: [merged]
 fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:06 -0800
Message-ID: <52e2b8ae.b1jDZWFcsED2U0aH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaAXTCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, todor@minchev.co.uk

Subject: [merged] fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch removed from -mm tree
To: todor@minchev.co.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:06 -0800


The patch titled
     Subject: fs: binfmt_elf: remove unused defines INTERPRETER_NONE and INTERPRETER_ELF
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Todor Minchev <todor@minchev.co.uk>
Subject: fs: binfmt_elf: remove unused defines INTERPRETER_NONE and INTERPRETER_ELF

These two defines are unused since the removal of the a.out interpreter
support in the ELF loader in kernel 2.6.25

Signed-off-by: Todor Minchev <todor@minchev.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf
+++ a/fs/binfmt_elf.c
@@ -543,9 +543,6 @@ out:
  * libraries.  There is no binary dependent code anywhere else.
  */
 
-#define INTERPRETER_NONE 0
-#define INTERPRETER_ELF 2
