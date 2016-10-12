From: akpm@linux-foundation.org
Subject: [merged]
 config-android-set-selinux-as-default-security-mode.patch removed from -mm
 tree
Date: Wed, 12 Oct 2016 12:25:31 -0700
Message-ID: <57fe8e2b.ydaZqE6C3N+NPOoU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33429 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755918AbcJLTZc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robh@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: config: android: set SELinux as default security mode
has been removed from the -mm tree.  Its filename was
     config-android-set-selinux-as-default-security-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: config: android: set SELinux as default security mode

Android won't boot without SELinux enabled, so make it the default.

Link: http://lkml.kernel.org/r/20160908185934.18098-2-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/configs/android-base.config~config-android-set-selinux-as-default-security-mode kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-set-selinux-as-default-security-mode
+++ a/kernel/configs/android-base.config
@@ -18,6 +18,7 @@ CONFIG_CGROUP_DEBUG=y
 CONFIG_CGROUP_FREEZER=y
 CONFIG_CGROUP_SCHED=y
 CONFIG_CP15_BARRIER_EMULATION=y
+CONFIG_DEFAULT_SECURITY_SELINUX=y
 CONFIG_EMBEDDED=y
 CONFIG_FB=y
 CONFIG_HIGH_RES_TIMERS=y
_

Patches currently in -mm which might be from robh@kernel.org are


