From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -
 slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 5 Nov 2007 14:18:30 -0800
Message-ID: <20071105141830.6aa249af.akpm@linux-foundation.org>
References: <200711052206.lA5M6G37022002@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0711051407590.20032@schroedinger.engr.sgi.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbXKEWTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 17:19:07 -0500
In-Reply-To: <Pine.LNX.4.64.0711051407590.20032@schroedinger.engr.sgi.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Christoph Lameter <clameter@sgi.com>
Cc: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org

On Mon, 5 Nov 2007 14:09:06 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 5 Nov 2007, akpm@linux-foundation.org wrote:
> 
> > This patch was dropped because of conflicts
> 
> I provided this patch for you on saturday to avoid the conflict:

That doesn't work very well once Linus has merged the mainline patch.

I spose I could revert his bit and reapply this bit. Let me play with that..
