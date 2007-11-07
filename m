From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - unexport-asm-pageh.patch removed from -mm tree
Date: Wed, 7 Nov 2007 14:15:52 -0800
Message-ID: <20071107141552.e574e5af.akpm@linux-foundation.org>
References: <200711072155.lA7Ltjm2029798@imap1.linux-foundation.org>
	<1194473308.11490.95.camel@pmac.infradead.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544AbXKGWQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 17:16:29 -0500
In-Reply-To: <1194473308.11490.95.camel@pmac.infradead.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: k.shutemov@gmail.com, dhowells@redhat.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org

> On Wed, 07 Nov 2007 22:08:28 +0000 David Woodhouse <dwmw2@infradead.org> wrote:
> 
> On Wed, 2007-11-07 at 13:55 -0800, akpm@linux-foundation.org wrote:
> > This patch was dropped because it had testing failures
> 
> Hm. Reference? It ought to have been a NOP in the kernel.
> 


Kamalesh, lkml, power4.  power4 and ia64's elf.h's include page.h.
