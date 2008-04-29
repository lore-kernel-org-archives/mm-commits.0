From: akpm@linux-foundation.org
Subject: - cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:35:56 -0700
Message-ID: <200804290535.m3T5ZuAX003291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbYD2FgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     someone mucked around with the cgroup api; this should fix it:
has been removed from the -mm tree.  Its filename was
     cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch

This patch was dropped because it was folded into cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: someone mucked around with the cgroup api; this should fix it:
From: Peter Zijlstra <peterz@infradead.org>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix kernel/sched.c
--- a/kernel/sched.c~cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix
+++ a/kernel/sched.c
@@ -8325,8 +8325,8 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "rt_period_us",
-		.read_uint = cpu_rt_period_read_uint,
-		.write_uint = cpu_rt_period_write_uint,
+		.read_u64 = cpu_rt_period_read_uint,
+		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
 };
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch

