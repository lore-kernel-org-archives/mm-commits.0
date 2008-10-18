From: akpm@linux-foundation.org
Subject: - container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:41:53 -0700
Message-ID: <200810182341.m9INfrsr000412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYJRXnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, clg@fr.ibm.com, pavel@suse.cz, rjw@sisk.pl, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: cleanup comment.
has been removed from the -mm tree.  Its filename was
     container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch

This patch was dropped because it was folded into container-freezer-implement-freezer-cgroup-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: cleanup comment.
From: Matt Helsley <matthltc@us.ibm.com>

Make this comment clearer.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup_freezer.c~container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment
+++ a/kernel/cgroup_freezer.c
@@ -61,8 +61,8 @@ int cgroup_frozen(struct task_struct *ta
 }
 
 /*
- * Buffer size for freezer state is limited by cgroups write_string()
- * interface. See cgroups code for the current size.
+ * cgroups_write_string() limits the size of freezer state strings to
+ * CGROUP_LOCAL_BUFFER_SIZE
  */
 static const char *freezer_state_strs[] = {
 	"RUNNING",
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch
container-freezer-make-freezer-state-names-less-generic.patch
container-freezer-rename-check_if_frozen.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch

