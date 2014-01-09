From: akpm@linux-foundation.org
Subject: +
 fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch added to -mm tree
Date: Wed, 08 Jan 2014 16:10:59 -0800
Message-ID: <52cde913.8SNr8B32+gxtlweM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAIALA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jan 2014 19:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, todor@minchev.co.uk

Subject: + fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch added to -mm tree
To: todor@minchev.co.uk
From: akpm@linux-foundation.org
Date: Wed, 08 Jan 2014 16:10:59 -0800


The patch titled
     Subject: fs: binfmt_elf: remove unused defines INTERPRETER_NONE and INTERPRETER_ELF
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-remove-unused-defines-interpreter_none-and-interpreter_elf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
