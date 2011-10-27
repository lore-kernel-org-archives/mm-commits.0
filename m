From: akpm@linux-foundation.org
Subject: [merged] m32r-allow-use-of-atomic64.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:40 -0700
Message-ID: <201110272308.p9RN8ehh021350@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:48950 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1J0XJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: allow use of atomic64
has been removed from the -mm tree.  Its filename was
     m32r-allow-use-of-atomic64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: m32r: allow use of atomic64

Atomic64 is now a valid type in Linux. Archs that do not have their own
version of atomic64 operators are to use the generic operations.

The m32r architecture needs to define GENERIC_ATOMIC64.

Link: http://lkml.kernel.org/r/20111013085936.GA13046@elte.hu

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/Kconfig~m32r-allow-use-of-atomic64 arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-allow-use-of-atomic64
+++ a/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ATOMIC64
 
 config SBUS
 	bool
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch
memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch

