From: akpm@linux-foundation.org
Subject: - documentation-describe-bootmem_debug-kernel-parameter.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:48:57 -0700
Message-ID: <200808210348.m7L3mv2t015592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbYHUDuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.herrmann3@amd.com, hannes@saeurebad.de, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     documentation: describe bootmem_debug kernel parameter
has been removed from the -mm tree.  Its filename was
     documentation-describe-bootmem_debug-kernel-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -365,6 +365,8 @@ and is between 256 and 4096 characters. 
 			no delay (0).
 			Format: integer
 
+	bootmem_debug	[KNL] Enable bootmem allocator debug messages.
+
 	bttv.card=	[HW,V4L] bttv (bt848 + bt878 based grabber cards)
 	bttv.radio=	Most important insmod options are available as
 			kernel args too.
_

Patches currently in -mm which might be from andreas.herrmann3@amd.com are

linux-next.patch

