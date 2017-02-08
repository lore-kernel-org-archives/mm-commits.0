From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 8 Feb 2017 14:30:45 -0800
Message-ID: <20170208143045.9b7c406c15c53dbf5a668d18@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdBHWaq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 17:30:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

4 fixes, based on 926af6273fc683cd98cd0ce7bf0d04a02eed6742:

Subject: kernel/ucount.c: mark user_header with kmemleak_ignore()
Subject: mm: avoid returning VM_FAULT_RETRY from ->page_mkwrite handlers
Subject: cpumask: use nr_cpumask_bits for parsing functions
Subject: mm/slub.c: fix random_seq offset destruction
