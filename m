From: akpm@linux-foundation.org
Subject: - containersv10-make-cpusets-a-client-of-containers-whitespace.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:29:38 -0700
Message-ID: <200707202029.l6KKTcIf014891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138AbXGTUbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:31:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     trivial whitespace fixes in kernel/cpuset.c
has been removed from the -mm tree.  Its filename was
     containersv10-make-cpusets-a-client-of-containers-whitespace.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: trivial whitespace fixes in kernel/cpuset.c
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~containersv10-make-cpusets-a-client-of-containers-whitespace kernel/cpuset.c
--- a/kernel/cpuset.c~containersv10-make-cpusets-a-client-of-containers-whitespace
+++ a/kernel/cpuset.c
@@ -513,7 +513,7 @@ static int update_cpumask(struct cpuset 
 	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
 	/* cpus_allowed cannot be empty for a cpuset with attached tasks. */
 	if (container_task_count(cs->css.container) &&
-            cpus_empty(trialcs.cpus_allowed))
+	    cpus_empty(trialcs.cpus_allowed))
 		return -ENOSPC;
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
_

Patches currently in -mm which might be from dwalker@mvista.com are

containersv10-make-cpusets-a-client-of-containers-whitespace.patch
containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
profile-likely-unlikely-macros.patch
