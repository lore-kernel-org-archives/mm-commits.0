From: akpm@linux-foundation.org
Subject: [patch 075/102] config: android: set SELinux as default security
 mode
Date: Tue, 11 Oct 2016 13:54:41 -0700
Message-ID: <57fd5191.ubpOj5EqsmUNPpgH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbcJKVAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 17:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, robh@kernel.org

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
