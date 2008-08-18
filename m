From: akpm@linux-foundation.org
Subject: + documentation-describe-bootmem_debug-kernel-parameter.patch added to -mm tree
Date: Mon, 18 Aug 2008 13:58:41 -0700
Message-ID: <200808182058.m7IKwfa9012353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYHRU7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 16:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.herrmann3@amd.com, hannes@saeurebad.de, mingo@elte.hu, randy.dunlap@oracle.com


The patch titled
     documentation: describe bootmem_debug kernel parameter
has been added to the -mm tree.  Its filename is
     documentation-describe-bootmem_debug-kernel-parameter.patch

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
Subject: documentation: describe bootmem_debug kernel parameter
From: Andreas Herrmann <andreas.herrmann3@amd.com>

"bootmem_debug" is not mentioned in kernel-parameters.txt. Recently I
had to use that kernel option and I think it should be documented.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/kernel-parameters.txt~documentation-describe-bootmem_debug-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-describe-bootmem_debug-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -430,6 +430,8 @@ and is between 256 and 4096 characters. 
 			no delay (0).
 			Format: integer
 
+	bootmem_debug	[KNL] Enable bootmem allocator debug messages.
+
 	bttv.card=	[HW,V4L] bttv (bt848 + bt878 based grabber cards)
 	bttv.radio=	Most important insmod options are available as
 			kernel args too.
_

Patches currently in -mm which might be from andreas.herrmann3@amd.com are

documentation-describe-bootmem_debug-kernel-parameter.patch
linux-next.patch
bootmem-fix-aligning-of-node-relative-indexes-and-offsets.patch

