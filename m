From: akpm@linux-foundation.org
Subject: - git-pcmcia.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:27:24 -0700
Message-ID: <200708250327.l7P3ROxL028140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbXHYD1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     git-pcmcia.patch
has been removed from the -mm tree.  Its filename was
     git-pcmcia.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-pcmcia.patch

GIT 38f66f234e94015e20ba4bfd8bfe3c652219d209 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git/

commit 
Author: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Date:   Fri Dec 8 18:07:01 2006 +0100

    [PATCH] PCMCIA: fix drivers broken by recent cleanup
    
    Setting .ConfigBase and .Present is now done at the pcmcia core. the driver
    cleanup missed a few places where the driver did set .Present to PRESENT_OPTION
    and later to the values from the CIS. setting to PRESENT_OPTION now overrides
    the values from the CIS. so just remove those lines.
    
    Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
    Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch
