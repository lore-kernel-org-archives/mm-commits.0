From: akpm@linux-foundation.org
Subject: + namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:28:24 -0700
Message-ID: <201010202328.o9KNSOSx010932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab0JTX2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, lizf@cn.fujitsu.com, menage@google.com, serue@us.ibm.com


The patch titled
     namespaces Kconfig: remove the cgroup device whitelist experimental tag
has been added to the -mm tree.  Its filename is
     namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces Kconfig: remove the cgroup device whitelist experimental tag
From: Daniel Lezcano <daniel.lezcano@free.fr>

This subsystem is merged since a long time now, I think we can consider it
mature enough.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN init/Kconfig~namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag init/Kconfig
--- a/init/Kconfig~namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag
+++ a/init/Kconfig
@@ -542,7 +542,6 @@ config CGROUP_FREEZER
 
 config CGROUP_DEVICE
 	bool "Device controller for cgroups"
-	depends on EXPERIMENTAL
 	help
 	  Provides a cgroup implementing whitelists for devices which
 	  a process in the cgroup can mknod or open.
_

Patches currently in -mm which might be from daniel.lezcano@free.fr are

linux-next.patch
cgroup-add-clone_children-control-file.patch
cgroup-make-the-mount-options-parsing-more-accurate.patch
cgroup-notify-ns_cgroup-deprecated.patch
namespaces-remove-pid_ns-and-net_ns-experimental-status.patch
namespaces-default-all-the-namespaces-to-yes-when-config_namespaces-is-selected.patch
namespaces-kconfig-make-namespace-a-submenu.patch
namespaces-kconfig-remove-pointless-cgroup-dependency.patch
namespaces-kconfig-remove-the-cgroup-device-whitelist-experimental-tag.patch
namespaces-kconfig-move-namespace-menu-location-after-the-cgroup.patch

