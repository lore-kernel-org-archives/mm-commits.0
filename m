From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmotm git repository
Date: Tue, 16 Dec 2008 11:43:43 -0800
Message-ID: <20081216114343.2ca29bdf.akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbYLPTnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 14:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Cc: jT <toyj@union.edu>


"mmotm" is the "-mm tree of the moment" tree.  The -mm patch pile, updated
usually more than once per day.

Thus far the mmotm tree has been available in `quilt' form, at
http://userweb.kernel.org/~akpm/mmotm/.

Each time the mmotm tree is re-uploaded an announcement is sent to the
mm-commits@vger.kernel.org list.  (echo subscribe mm-commits | mail
majordomo@vger.kernel.org).


jT <toyj@union.edu> has developed scripts to pull the mmotm tree down
into a git tree (thanks!), available via

	git clone git://git.zen-sources.org/zen/mmotm.git

browseable here:

	http://git.zen-sources.org/?p=mmotm.git;a=summary

The patch titles are all screwed up - that's my fault, because the
.patch files don't include the title - I'll fix that sometime. 


This is all very new and I don't know what the update latency is.
