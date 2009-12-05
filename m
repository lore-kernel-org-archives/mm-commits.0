From: akpm@linux-foundation.org
Subject: + drivers-staging-wlags49_h2-remove-cvs-metadata.patch added to -mm tree
Date: Fri, 04 Dec 2009 17:05:45 -0800
Message-ID: <200912050105.nB515jok000340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757550AbZLEBFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 20:05:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, pe1dnn@amsat.org, randy.dunlap@oracle.com


The patch titled
     drivers/staging/wlags49_h2: remove cvs metadata
has been added to the -mm tree.  Its filename is
     drivers-staging-wlags49_h2-remove-cvs-metadata.patch

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
Subject: drivers/staging/wlags49_h2: remove cvs metadata
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Henk de Groot <pe1dnn@amsat.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/wlags49_h2/debug.h       |   17 -----------------
 drivers/staging/wlags49_h2/dhfcfg.h      |   17 -----------------
 drivers/staging/wlags49_h2/wl_cs.c       |   13 -------------
 drivers/staging/wlags49_h2/wl_cs.h       |   17 -----------------
 drivers/staging/wlags49_h2/wl_enc.c      |   17 -----------------
 drivers/staging/wlags49_h2/wl_enc.h      |   17 -----------------
 drivers/staging/wlags49_h2/wl_if.h       |   17 -----------------
 drivers/staging/wlags49_h2/wl_internal.h |   17 -----------------
 drivers/staging/wlags49_h2/wl_main.c     |   12 ------------
 drivers/staging/wlags49_h2/wl_main.h     |   17 -----------------
 drivers/staging/wlags49_h2/wl_netdev.c   |   15 ---------------
 drivers/staging/wlags49_h2/wl_netdev.h   |   17 -----------------
 drivers/staging/wlags49_h2/wl_pci.c      |   15 ---------------
 drivers/staging/wlags49_h2/wl_pci.h      |   17 -----------------
 drivers/staging/wlags49_h2/wl_priv.c     |   17 -----------------
 drivers/staging/wlags49_h2/wl_priv.h     |   17 -----------------
 drivers/staging/wlags49_h2/wl_profile.c  |   17 -----------------
 drivers/staging/wlags49_h2/wl_profile.h  |   17 -----------------
 drivers/staging/wlags49_h2/wl_util.c     |   17 -----------------
 drivers/staging/wlags49_h2/wl_util.h     |   14 --------------
 drivers/staging/wlags49_h2/wl_version.h  |   14 --------------
 drivers/staging/wlags49_h2/wl_wext.c     |   17 -----------------
 drivers/staging/wlags49_h2/wl_wext.h     |   17 -----------------
 23 files changed, 372 deletions(-)

diff -puN drivers/staging/wlags49_h2/debug.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/debug.h
--- a/drivers/staging/wlags49_h2/debug.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/debug.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/20 09:29:45 $
- * $Revision: 1.3 $
- * $Source: /usr/local/cvs/wl_lkm/include/hcf/debug.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef _DEBUG_H
 #define _DEBUG_H
 
diff -puN drivers/staging/wlags49_h2/dhfcfg.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/dhfcfg.h
--- a/drivers/staging/wlags49_h2/dhfcfg.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/dhfcfg.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 07:08:33 $
- * $Revision: 1.1.1.1 $
- * $Source: /usr/local/cvs/wl_lkm/include/hcf/dhfcfg.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef DHFCFG_H
 #define DHFCFG_H
 /*-----------------------------------------------------------------------------
diff -puN drivers/staging/wlags49_h2/wl_cs.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_cs.c
--- a/drivers/staging/wlags49_h2/wl_cs.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_cs.c
@@ -59,19 +59,6 @@
  *
  ******************************************************************************/
 
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/06 11:25:37 $
- * $Revision: 1.5 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_cs.c,v $
- *
- ******************************************************************************/
-
-
 /*******************************************************************************
  *  include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_cs.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_cs.h
--- a/drivers/staging/wlags49_h2/wl_cs.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_cs.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_cs.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_CS_H__
 #define __WL_CS_H__
 
diff -puN drivers/staging/wlags49_h2/wl_enc.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_enc.c
--- a/drivers/staging/wlags49_h2/wl_enc.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_enc.c
@@ -59,23 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_enc.c,v $
- *
- ******************************************************************************/
-
-
-
-
 /*******************************************************************************
  *  include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_enc.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_enc.h
--- a/drivers/staging/wlags49_h2/wl_enc.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_enc.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_enc.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WAVELAN2_ENCRYPTION_H__
 #define __WAVELAN2_ENCRYPTION_H__
 
diff -puN drivers/staging/wlags49_h2/wl_if.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_if.h
--- a/drivers/staging/wlags49_h2/wl_if.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_if.h
@@ -59,23 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_if.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WAVELAN2_IF_H__
 #define __WAVELAN2_IF_H__
 
diff -puN drivers/staging/wlags49_h2/wl_internal.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_internal.h
--- a/drivers/staging/wlags49_h2/wl_internal.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_internal.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/03 11:39:39 $
- * $Revision: 1.8 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_internal.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WAVELAN2_H__
 #define __WAVELAN2_H__
 
diff -puN drivers/staging/wlags49_h2/wl_main.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_main.c
--- a/drivers/staging/wlags49_h2/wl_main.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_main.c
@@ -59,18 +59,6 @@
  *
  ******************************************************************************/
 
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/06 11:25:37 $
- * $Revision: 1.14 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_main.c,v $
- *
- ******************************************************************************/
-
 /*******************************************************************************
  *  constant definitions
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_main.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_main.h
--- a/drivers/staging/wlags49_h2/wl_main.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_main.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/23 04:51:21 $
- * $Revision: 1.4 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_main.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_MAIN_H__
 #define __WL_MAIN_H__
 
diff -puN drivers/staging/wlags49_h2/wl_netdev.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_netdev.c
--- a/drivers/staging/wlags49_h2/wl_netdev.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_netdev.c
@@ -59,21 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/03 13:33:44 $
- * $Revision: 1.8 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_netdev.c,v $
- *
- ******************************************************************************/
-
-
-
 /*******************************************************************************
  * include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_netdev.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_netdev.h
--- a/drivers/staging/wlags49_h2/wl_netdev.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_netdev.h
@@ -59,23 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_netdev.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_NETDEV_H__
 #define __WL_NETDEV_H__
 
diff -puN drivers/staging/wlags49_h2/wl_pci.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_pci.c
--- a/drivers/staging/wlags49_h2/wl_pci.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_pci.c
@@ -59,21 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/06 11:25:37 $
- * $Revision: 1.7 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_pci.c,v $
- *
- ******************************************************************************/
-
-
-
 /*******************************************************************************
  * include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_pci.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_pci.h
--- a/drivers/staging/wlags49_h2/wl_pci.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_pci.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_pci.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_PCI_H__
 #define __WL_PCI_H__
 
diff -puN drivers/staging/wlags49_h2/wl_priv.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_priv.c
--- a/drivers/staging/wlags49_h2/wl_priv.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_priv.c
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/03 11:39:39 $
- * $Revision: 1.5 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_priv.c,v $
- *
- ******************************************************************************/
-
-
-
-
 /*******************************************************************************
  * include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_priv.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_priv.h
--- a/drivers/staging/wlags49_h2/wl_priv.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_priv.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_priv.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_PRIV_H__
 #define __WL_PRIV_H__
 
diff -puN drivers/staging/wlags49_h2/wl_profile.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_profile.c
--- a/drivers/staging/wlags49_h2/wl_profile.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_profile.c
@@ -59,23 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/04 12:36:10 $
- * $Revision: 1.10 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_profile.c,v $
- *
- ******************************************************************************/
-
-
-
-
 /* Only include this file if USE_PROFILE is defined */
 #ifdef USE_PROFILE
 
diff -puN drivers/staging/wlags49_h2/wl_profile.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_profile.h
--- a/drivers/staging/wlags49_h2/wl_profile.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_profile.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/23 11:46:19 $
- * $Revision: 1.3 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_profile.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_PROFILE_H__
 #define __WL_PROFILE_H__
 
diff -puN drivers/staging/wlags49_h2/wl_util.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_util.c
--- a/drivers/staging/wlags49_h2/wl_util.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_util.c
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/04 12:36:10 $
- * $Revision: 1.6 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_util.c,v $
- *
- ******************************************************************************/
-
-
-
-
 /*******************************************************************************
  *  include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_util.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_util.h
--- a/drivers/staging/wlags49_h2/wl_util.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_util.h
@@ -59,20 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_util.h,v $
- *
- ******************************************************************************/
-
 #ifndef __WL_UTIL_H__
 #define __WL_UTIL_H__
 
diff -puN drivers/staging/wlags49_h2/wl_version.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_version.h
--- a/drivers/staging/wlags49_h2/wl_version.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_version.h
@@ -59,20 +59,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/04 12:36:10 $
- * $Revision: 1.7 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_version.h,v $
- *
- ******************************************************************************/
-
 #ifndef __WL_VERSION_H__
 #define __WL_VERSION_H__
 
diff -puN drivers/staging/wlags49_h2/wl_wext.c~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_wext.c
--- a/drivers/staging/wlags49_h2/wl_wext.c~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_wext.c
@@ -54,23 +54,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/08/03 11:39:39 $
- * $Revision: 1.6 $
- * $Source: /usr/local/cvs/wl_lkm/wireless/wl_wext.c,v $
- *
- ******************************************************************************/
-
-
-
-
 /*******************************************************************************
  *  include files
  ******************************************************************************/
diff -puN drivers/staging/wlags49_h2/wl_wext.h~drivers-staging-wlags49_h2-remove-cvs-metadata drivers/staging/wlags49_h2/wl_wext.h
--- a/drivers/staging/wlags49_h2/wl_wext.h~drivers-staging-wlags49_h2-remove-cvs-metadata
+++ a/drivers/staging/wlags49_h2/wl_wext.h
@@ -58,23 +58,6 @@
  *
  ******************************************************************************/
 
-
-
-
-/*******************************************************************************
- * VERSION CONTROL INFORMATION
- *******************************************************************************
- *
- * $Author: nico $
- * $Date: 2004/07/19 08:16:15 $
- * $Revision: 1.2 $
- * $Source: /usr/local/cvs/wl_lkm/include/wireless/wl_wext.h,v $
- *
- ******************************************************************************/
-
-
-
-
 #ifndef __WL_WEXT_H__
 #define __WL_WEXT_H__
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
drivers-staging-wlags49_h2-remove-cvs-metadata.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
net-rfkill-corec-work-around-gcc-402-silliness.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
ip2-remove-ifdef-module-from-ip2mainc-fix.patch
drivers-edac-amd64_edacc-fix-use-uninitialised-bug.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

