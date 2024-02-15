Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB45F14A086
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041014; cv=none; b=qRi2J62uHlQ1YuWTukdnwweQvNq2F7Xe6QLOfd4NdVwnuUojNSNQSHkgi5qhM10BKfB7rSMvfeLzVI4kNwI3OZTPTHCXRwm1FPwStoww/IsuNeuOmU3Gc8yet5OltJPOvBFX8AkeUys5G65ikBNzc2h1meI38zumysMqFLWSeV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041014; c=relaxed/simple;
	bh=yNXpyvMp+X4MgWzOnGsUYBuL0caQ2ja9Nm5W30lOKLk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJhxW0qAZ/O6ed/3QYkFfiWPTTN4wHYMrQjcqV1f1m/0P1gJH09dXThfv+HjmirM5u9yfGR5VUesiD4KvgU/GBDtYd0vd3wNxJEhmbimZW7plCGkHyYpXIAyLw8rDLVH8Ky1slEJnSE9bUNv+IXq+SDq+1hdadjMyJptlzvEwAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7010C433F1;
	Thu, 15 Feb 2024 23:50:13 +0000 (UTC)
Date: Thu, 15 Feb 2024 18:51:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rdunlap@infradead.org,
 andriy.shevchenko@linux.intel.com
Subject: Re: + seq_buf-fix-kernel-documentation.patch added to
 mm-nonmm-unstable branch
Message-ID: <20240215185148.216646cf@gandalf.local.home>
In-Reply-To: <20240215234006.3A55EC433C7@smtp.kernel.org>
References: <20240215234006.3A55EC433C7@smtp.kernel.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Feb 2024 15:40:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> The patch titled
>      Subject: seq_buf: fix kernel documentation
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      seq_buf-fix-kernel-documentation.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/seq_buf-fix-kernel-documentation.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>

Hi Andrew,

I've applied this to my tree and will be sending to Linus soon.

-- Steve
