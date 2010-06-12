From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Date: Fri, 11 Jun 2010 17:22:35 -0700
Message-ID: <20100611172235.a32b91ec.akpm__8069.00518150559$1276302171$gmane$org@linux-foundation.org>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab0FLAWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 20:22:38 -0400
In-Reply-To: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 16:40:13 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git

This oopses for me in get_ksymbol() (a linux-next bug).  I didn't have
time to find out why.  But presumably it isn't oopsing for other
linux-next testers.

