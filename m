From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - serial-use-resource_size_t-for-port-io-addresses.patch
 removed from -mm tree
Date: Mon, 4 Jun 2007 20:24:30 -0700
Message-ID: <20070604202430.04348fa8.akpm@linux-foundation.org>
References: <200705301857.l4UIvsCN002172@shell0.pdx.osdl.net>
	<20070605031638.GA26469@localhost.localdomain>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757657AbXFEDY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 23:24:58 -0400
In-Reply-To: <20070605031638.GA26469@localhost.localdomain>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: alan@lxorguk.ukuu.org.uk, kebkal@gmail.com, ralf@linux-mips.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org

On Tue, 5 Jun 2007 13:16:38 +1000 David Gibson <david@gibson.dropbear.id.au> wrote:

> On Wed, May 30, 2007 at 11:57:54AM -0700, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      serial: use resource_size_t for port IO addresses
> > has been removed from the -mm tree.  Its filename was
> >      serial-use-resource_size_t-for-port-io-addresses.patch
> > 
> > This patch was dropped because I merged Yinghai Lu's stuff instead
> 
> Sorry, can you tell me which patches in the -mm series constitute
> Yinghai Lu's stuff, so that I can grab them and update my stuff as
> appropriate?

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
x86-initial-fixmap-support.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-assert-dtr-for-serial-console-devices.patch

spose I should do another -mm.  But there's still another 100-odd patches
to go through from the weekend.  Ho hum.
