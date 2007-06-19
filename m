From: akpm@linux-foundation.org
Subject: + containersv10-support-for-automatic-userspace-release-agents-whitespace.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:57:23 -0700
Message-ID: <200706191857.l5JIvNSt018555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763869AbXFSS6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, menage@google.com


The patch titled
     trivial whitespace fixes in kernel/container.c
has been added to the -mm tree.  Its filename is
     containersv10-support-for-automatic-userspace-release-agents-whitespace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: trivial whitespace fixes in kernel/container.c
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/container.c~containersv10-support-for-automatic-userspace-release-agents-whitespace kernel/container.c
--- a/kernel/container.c~containersv10-support-for-automatic-userspace-release-agents-whitespace
+++ a/kernel/container.c
@@ -1759,7 +1759,7 @@ static int container_populate_dir(struct
 	container_clear_directory(cont->dentry);
 
 	err = container_add_files(cont, files, ARRAY_SIZE(files));
-     	if (err < 0)
+	if (err < 0)
 		return err;
 
 	if (cont == cont->top_container) {
@@ -1987,15 +1987,15 @@ static void container_init_subsys(struct
  	/* If this subsystem requested that it be notified with fork
  	 * events, we should send it one now for every process in the
  	 * system */
- 	if (ss->fork) {
- 		struct task_struct *g, *p;
+	if (ss->fork) {
+		struct task_struct *g, *p;
 
- 		read_lock(&tasklist_lock);
- 		do_each_thread(g, p) {
- 			ss->fork(ss, p);
- 		} while_each_thread(g, p);
- 		read_unlock(&tasklist_lock);
- 	}
+		read_lock(&tasklist_lock);
+		do_each_thread(g, p) {
+			ss->fork(ss, p);
+		} while_each_thread(g, p);
+		read_unlock(&tasklist_lock);
+	}
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

containersv10-make-cpusets-a-client-of-containers-whitespace.patch
containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
profile-likely-unlikely-macros.patch
