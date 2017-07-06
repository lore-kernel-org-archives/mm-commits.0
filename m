From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch removed
 from -mm tree
Date: Thu, 06 Jul 2017 15:21:07 -0700
Message-ID: <595eb7d3.NagTEPTcwjg8TeJ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdGFWVI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, guroan@gmail.com, khlebnikov@yandex-team.ru, mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch

This patch was dropped because it was folded into mm-oom_kill-count-global-and-memory-cgroup-oom-kills.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix

fix comment, per Konstantin

Cc: David Rientjes <rientjes@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Guschin <guroan@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix
+++ a/mm/oom_kill.c
@@ -877,7 +877,7 @@ static void oom_kill_process(struct oom_
 	mm = victim->mm;
 	mmgrab(mm);
 
-	/* Raise event before sending signal: reaper must see this */
+	/* Raise event before sending signal: task reaper must see this */
 	count_vm_event(OOM_KILL);
 	count_memcg_event_mm(mm, OOM_KILL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills.patch
mm-swap-sort-swap-entries-before-free-fix.patch

