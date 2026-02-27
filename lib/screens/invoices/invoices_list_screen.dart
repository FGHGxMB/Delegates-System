import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/invoices_dao.dart';
import '../../database/database.dart';

class InvoicesListScreen extends ConsumerWidget {
  const InvoicesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.invoices),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs:[
              Tab(text: 'المبيعات', icon: Icon(Icons.shopping_cart)),
              Tab(text: 'المرتجعات', icon: Icon(Icons.assignment_return)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // سؤال المندوب: هل يريد فاتورة مبيعات أم مرتجعات؟
            showModalBottomSheet(
              context: context,
              builder: (ctx) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    ListTile(
                      leading: const Icon(Icons.shopping_cart, color: AppColors.primary),
                      title: const Text(AppStrings.newSalesInvoice),
                      onTap: () {
                        Navigator.pop(ctx);
                        context.push('/invoice_form/SALE/0');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.assignment_return, color: Colors.orange),
                      title: const Text(AppStrings.newReturnInvoice),
                      onTap: () {
                        Navigator.pop(ctx);
                        context.push('/invoice_form/RETURN/0');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: const TabBarView(
          children:[
            _InvoiceListTab(type: 'SALE'),
            _InvoiceListTab(type: 'RETURN'),
          ],
        ),
      ),
    );
  }
}

class _InvoiceListTab extends ConsumerWidget {
  final String type;
  const _InvoiceListTab({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.watch(invoicesDaoProvider);

    return StreamBuilder<List<Invoice>>(
      stream: dao.watchInvoices(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final invoices = snapshot.data ??[];

        if (invoices.isEmpty) {
          return const Center(child: Text(AppStrings.noData));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index];

            // تحديد لون واسم الحالة
            Color statusColor = AppColors.draftColor;
            String statusText = AppStrings.invoiceDraft;

            if (invoice.status == 'ISSUED') {
              statusColor = AppColors.issuedColor;
              statusText = AppStrings.invoiceIssued;
            } else if (invoice.status == 'SENT') {
              statusColor = AppColors.sentColor;
              statusText = AppStrings.invoiceSent;
            }

            return Card(
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.2),
                  child: Icon(
                    type == 'SALE' ? Icons.shopping_cart : Icons.assignment_return,
                    color: statusColor,
                  ),
                ),
                title: Text(
                  'فاتورة رقم: ${invoice.invoiceNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${invoice.date} | الإجمالي: ${invoice.total} ${invoice.currency}'),
                trailing: Chip(
                  label: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 10)),
                  backgroundColor: statusColor,
                ),
                onTap: () {
                  context.push('/invoice_form/${invoice.type}/${invoice.id}');
                },
              ),
            );
          },
        );
      },
    );
  }
}