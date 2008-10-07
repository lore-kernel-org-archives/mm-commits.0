From: akpm@linux-foundation.org
Subject: - cpu_alloc-remove-useless-variable.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:35:31 -0700
Message-ID: <200810072335.m97NZVbg009263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbYJGXfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux-foundation.org, penberg@cs.helsinki.fi, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     cpu_alloc: remove useless variable
has been removed from the -mm tree.  Its filename was
     cpu_alloc-remove-useless-variable.patch

This patch was dropped because it got shat on

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu_alloc: remove useless variable
From: Christoph Lameter <cl@linux-foundation.org>

The "units" variable is a leftover and has no function at this point.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cpu_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/cpu_alloc.c~cpu_alloc-remove-useless-variable mm/cpu_alloc.c
--- a/mm/cpu_alloc.c~cpu_alloc-remove-useless-variable
+++ a/mm/cpu_alloc.c
@@ -27,8 +27,6 @@
 #define UNIT_TYPE int
 #define UNIT_SIZE sizeof(UNIT_TYPE)
 
-int units;	/* Actual available units */
