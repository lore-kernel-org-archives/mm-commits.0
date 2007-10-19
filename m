From: akpm@linux-foundation.org
Subject: - task-containers-enable-containers-by-default-in-some-configs.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:50:32 -0700
Message-ID: <200710192250.l9JMoWBs024096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967003AbXJSXFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     task cgroups: enable cgroups by default in some configs
has been removed from the -mm tree.  Its filename was
     task-containers-enable-containers-by-default-in-some-configs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: task cgroups: enable cgroups by default in some configs
From: Paul Jackson <pj@sgi.com>

In pre-cgroup cpusets, a few config files enabled cpusets by default. 

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/configs/sn2_defconfig          |    1 +
 arch/mips/configs/ip27_defconfig         |    1 +
 arch/mips/configs/sb1250-swarm_defconfig |    1 +
 arch/powerpc/configs/cell_defconfig      |    1 +
 arch/powerpc/configs/ppc64_defconfig     |    1 +
 arch/powerpc/configs/pseries_defconfig   |    1 +
 6 files changed, 6 insertions(+)

diff -puN arch/ia64/configs/sn2_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/ia64/configs/sn2_defconfig
--- a/arch/ia64/configs/sn2_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/ia64/configs/sn2_defconfig
@@ -26,6 +26,7 @@ CONFIG_TASK_IO_ACCOUNTING=y
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=20
+CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/mips/configs/ip27_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/mips/configs/ip27_defconfig
--- a/arch/mips/configs/ip27_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/mips/configs/ip27_defconfig
@@ -175,6 +175,7 @@ CONFIG_POSIX_MQUEUE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
+CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/mips/configs/sb1250-swarm_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/mips/configs/sb1250-swarm_defconfig
--- a/arch/mips/configs/sb1250-swarm_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/mips/configs/sb1250-swarm_defconfig
@@ -196,6 +196,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/powerpc/configs/cell_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/powerpc/configs/cell_defconfig
--- a/arch/powerpc/configs/cell_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/powerpc/configs/cell_defconfig
@@ -68,6 +68,7 @@ CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=15
+CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
diff -puN arch/powerpc/configs/ppc64_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/powerpc/configs/ppc64_defconfig
--- a/arch/powerpc/configs/ppc64_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -71,6 +71,7 @@ CONFIG_TASK_DELAY_ACCT=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
+CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
diff -puN arch/powerpc/configs/pseries_defconfig~task-containers-enable-containers-by-default-in-some-configs arch/powerpc/configs/pseries_defconfig
--- a/arch/powerpc/configs/pseries_defconfig~task-containers-enable-containers-by-default-in-some-configs
+++ a/arch/powerpc/configs/pseries_defconfig
@@ -71,6 +71,7 @@ CONFIG_AUDITSYSCALL=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=17
+CONFIG_CGROUPS=y
 CONFIG_CPUSETS=y
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
git-scsi-misc.patch
