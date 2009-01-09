From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - lis3lv02d-separate-the-core-from-hp-acpi-api.patch removed
 from -mm tree
Date: Fri, 9 Jan 2009 15:23:17 -0800
Message-ID: <20090109152317.ca2a2da8.akpm@linux-foundation.org>
References: <200901091958.n09JwbJs031498@imap1.linux-foundation.org>
	<20090109230003.GB2223@elf.ucw.cz>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932895AbZAIXX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 18:23:58 -0500
In-Reply-To: <20090109230003.GB2223@elf.ucw.cz>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net, mm-commits@vger.kernel.org

On Sat, 10 Jan 2009 00:00:03 +0100
Pavel Machek <pavel@suse.cz> wrote:

> > The patch titled
> >      LIS3LV02D: separate the core from HP ACPI API
> > has been removed from the -mm tree.  Its filename was
> >      lis3lv02d-separate-the-core-from-hp-acpi-api.patch
> > 
> > This patch was dropped because other changes were merged, which wrecked this patch
> 
> I'm confused. The other patch collided with leds/Makefile changes, but
> this one applies cleanly over Linus' git (updated today)... or am I
> doing something wrong? Could it still be pushed to Linus?

umm, sure, we can try that.

Please don't use vague terms like "the other patch".  I assume you're
referring to lis3lv02d-merge-with-leds-hp-disk.patch?

It has more problems than a simple makefile conflict.  People keep on
changing stuff in linux-next.  

