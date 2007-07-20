From: akpm@linux-foundation.org
Subject: - containersv10-support-for-automatic-userspace-release-agents-whitespace.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:30:01 -0700
Message-ID: <200707202030.l6KKU1HM014921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933811AbXGTUgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     trivial whitespace fixes in kernel/container.c
has been removed from the -mm tree.  Its filename was
     containersv10-support-for-automatic-userspace-release-agents-whitespace.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: trivial whitespace fixes in kernel/container.c
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/container.c~containersv10-support-for-automatic-userspace-release-agents-whitespace kernel/container.c
--- a/kernel/container.c~containersv10-support-for-automatic-userspace-release-agents-whitespace
+++ a/kernel/container.c
@@ -1760,7 +1760,7 @@ static int container_populate_dir(struct
 	container_clear_directory(cont->dentry);
 
 	err = container_add_files(cont, files, ARRAY_SIZE(files));
-     	if (err < 0)
+	if (err < 0)
 		return err;
 
 	if (cont == cont->top_container) {
@@ -1988,15 +1988,15 @@ static void container_init_subsys(struct
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

containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
profile-likely-unlikely-macros.patch
